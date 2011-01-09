require "json"

schemas = <<JSON
[
    {
        "logType": {
            "id": "logType",
            "description": "HTTP Archive structure.",
            "type": "object",
            "properties": {
                "log": {
                    "type": "object",
                    "properties": {
                        "version": {"type": "string"},
                        "creator": {"$ref": "creatorType"},
                        "browser": {"$ref": "browserType"},
                        "pages": {"type": "array", "optional": true, "items": {"$ref": "pageType"}},
                        "entries": {"type": "array", "items": {"$ref": "entryType"}},
                        "comment": {"type": "string", "optional": true}
                    }
                }
            }
        }
    },
    {
        "creatorType": {
            "id": "creatorType",
            "description": "Name and version info of the log creator app.",
            "type": "object",
            "properties": {
                "name": {"type": "string"},
                "version": {"type": "string"},
                "comment": {"type": "string", "optional": true}
            }
        }
    },
    {
        "browserType": {
            "id": "browserType",
            "description": "Name and version info of used browser.",
            "type": "object",
            "optional": true,
            "properties": {
                "name": {"type": "string"},
                "version": {"type": "string"},
                "comment": {"type": "string", "optional": true}
            }
        }
    },
    {
        "pageType": {
            "id": "pageType",
            "description": "Exported web page",
            "optional": true,
            "properties": {
                "startedDateTime": {"type": "string", "format": "date-time", "pattern": "^(\\d{4})(-)?(\\d\\d)(-)?(\\d\\d)(T)?(\\d\\d)(:)?(\\d\\d)(:)?(\\d\\d)(\\.\\d+)?(Z|([+-])(\\d\\d)(:)?(\\d\\d))"},
                "id": {"type": "string", "unique": true},
                "title": {"type": "string"},
                "pageTimings": {"$ref": "pageTimingsType"},
                "comment": {"type": "string", "optional": true}
            }
        }
    },
    {
        "pageTimingsType": {
            "id": "pageTimingsType",
            "description": "Timing info about page load",
            "properties": {
                "onContentLoad": {"type": "number", "optional": true, "min": -1},
                "onLoad": {"type": "number", "optional": true, "min": -1},
                "comment": {"type": "string", "optional": true}
            }
        }
    },

    {
        "entryType": {
            "id": "entryType",
            "description": "Request and Response related info",
            "optional": true,
            "properties": {
                "pageref": {"type": "string", "optional": true},
                "startedDateTime": {"type": "string", "format": "date-time", "pattern": "^(\\d{4})(-)?(\\d\\d)(-)?(\\d\\d)(T)?(\\d\\d)(:)?(\\d\\d)(:)?(\\d\\d)(\\.\\d+)?(Z|([+-])(\\d\\d)(:)?(\\d\\d))"},
                "time": {"type": "integer", "min": 0},
                "request" : {"$ref": "requestType"},
                "response" : {"$ref": "responseType"},
                "cache" : {"$ref": "cacheType"},
                "timings" : {"$ref": "timingsType"},
                "serverIPAddress" : {"type": "string", "optional": true},
                "connection" : {"type": "string", "optional": true},
                "comment": {"type": "string", "optional": true}
            }
        }
    },

    {
        "requestType": {
            "id": "requestType",
            "description": "Monitored request",
            "properties": {
                "method": {"type": "string"},
                "url": {"type": "string"},
                "httpVersion": {"type" : "string"},
                "cookies" : {"type": "array", "items": {"$ref": "cookieType"}},
                "headers" : {"type": "array", "items": {"$ref": "recordType"}},
                "queryString" : {"type": "array", "items": {"$ref": "recordType"}},
                "postData" : {"$ref": "postDataType"},
                "headersSize" : {"type": "integer"},
                "bodySize" : {"type": "integer"},
                "comment": {"type": "string", "optional": true}
            }
        }
    },

    {
        "recordType": {
            "id": "recordType",
            "description": "Helper name-value pair structure.",
            "properties": {
                "name": {"type": "string"},
                "value": {"type": "string"},
                "comment": {"type": "string", "optional": true}
            }
        }
    },

    {
        "responseType": {
            "id": "responseType",
            "description": "Monitored Response.",
            "properties": {
                "status": {"type": "integer"},
                "statusText": {"type": "string"},
                "httpVersion": {"type": "string"},
                "cookies" : {"type": "array", "items": {"$ref": "cookieType"}},
                "headers" : {"type": "array", "items": {"$ref": "recordType"}},
                "content" : {"$ref": "contentType"},
                "redirectURL" : {"type": "string"},
                "headersSize" : {"type": "integer"},
                "bodySize" : {"type": "integer"},
                "comment": {"type": "string", "optional": true}
            }
        }
    },

    {
        "cookieType": {
            "id": "cookieType",
            "description": "Cookie description.",
            "properties": {
                "name": {"type": "string"},
                "value": {"type": "string"},
                "path": {"type": "string", "optional": true},
                "domain" : {"type": "string", "optional": true},
                "expires" : {"type": "string", "optional": true},
                "httpOnly" : {"type": "boolean", "optional": true},
                "secure" : {"type": "boolean", "optional": true},
                "comment": {"type": "string", "optional": true}
            }
        }
    },
    {
        "postDataType": {
            "id": "postDataType",
            "description": "Posted data info.",
            "optional": true,
            "properties": {
                "mimeType": {"type": "string"},
                "text": {"type": "string", "optional": true},
                "params": {
                    "type": "array",
                    "optional": true,
                    "properties": {
                        "name": {"type": "string"},
                        "value": {"type": "string", "optional": true},
                        "fileName": {"type": "string", "optional": true},
                        "contentType": {"type": "string", "optional": true},
                        "comment": {"type": "string", "optional": true}
                    }
                },
                "comment": {"type": "string", "optional": true}
            }
        }
    },
    {
        "contentType": {
            "id": "contentType",
            "description": "Response content",
            "properties": {
                "size": {"type": "integer"},
                "compression": {"type": "integer", "optional": true},
                "mimeType": {"type": "string"},
                "text": {"type": "string", "optional": true},
                "encoding": {"type": "string", "optional": true},
                "comment": {"type": "string", "optional": true}
            }
        }
    },
    {
        "cacheType": {
            "id": "cacheType",
            "description": "Info about a response coming from the cache.",
            "properties": {
                "beforeRequest": {"$ref": "cacheEntryType"},
                "afterRequest": {"$ref": "cacheEntryType"},
                "comment": {"type": "string", "optional": true}
            }
        }
    },
    {
        "cacheEntryType": {
            "id": "cacheEntryType",
            "optional": true,
            "description": "Info about cache entry.",
            "properties": {
                "expires": {"type": "string", "optional": "true"},
                "lastAccess": {"type": "string"},
                "eTag": {"type": "string"},
                "hitCount": {"type": "integer"},
                "comment": {"type": "string", "optional": true}
            }
        }
    },
    {
        "timingsType": {
            "id": "timingsType",
            "description": "Info about request-response timing.",
            "properties": {
                "dns": {"type": "integer", "min": -1},
                "connect": {"type": "integer", "min": -1},
                "blocked": {"type": "integer", "min": -1},
                "send": {"type": "integer", "min": -1},
                "wait": {"type": "integer", "min": -1},
                "receive": {"type": "integer", "min": -1},
                "ssl": {"type": "integer", "optional": true, "min": -1},
                "comment": {"type": "string", "optional": true}
            }
        }
    }
]
JSON

root = File.dirname(__FILE__)
types.each do |type| 
  key = type.keys.first
  file = key #.gsub(/\B[A-Z][^A-Z]/, '_\&').downcase.gsub(' ', '_')
  path = File.join(root, "#{file}.json")
  
  File.open(path, "w") { |io| io << JSON.pretty_generate(type[key])}
end