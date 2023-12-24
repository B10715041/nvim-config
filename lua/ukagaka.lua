local notify = require("notify")
local json = require("dkjson")

math.randomseed(os.time())

-- Function to read quotes from a JSON file
local function read_quotes_from_json(file_path)
    local quotes = {}
    local file = io.open(file_path, "r")

    if file then
        local content = file:read("*a")
        quotes = json.decode(content)
        file:close()
    else
        print("Could not read quotes file: " .. file_path)
    end

    return quotes
end

local quotes_file_path = os.getenv("HOME") .. "/.config/nvim/lua/quotes.json"
local quotes = read_quotes_from_json(quotes_file_path)

-- Function to send a random quote
local function send_random_quote()
    if #quotes == 0 then
        print("No quotes available")
        return
    end
    local quote = quotes[math.random(#quotes)]
    notify(quote.content, "info", {
        title = quote.title,
        timeout = 1 * 60 * 1000,  -- last for 1 minutes
    })
end

-- Function to schedule sending quotes
local function schedule_quote()
    local interval = math.random(5, 20)  -- Random time between 5 and 20 minutes
    vim.defer_fn(function()
        send_random_quote()
        schedule_quote()  -- Schedule the next quote
    end, interval * 60 * 1000)  -- Convert seconds to milliseconds
end

-- Start the schedule
schedule_quote()

