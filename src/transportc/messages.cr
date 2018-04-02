require "json"

module TranspoRTC
    class BaseMessage
        def <<(string)
            JSON.parse(string)
        end
    end
end