local json = require("dkjson")
local notify = require("notify")
notify.setup({ background_colour = "#000000", })

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

local volume = "70"
local root = os.getenv("HOME") .. "/.config/nvim/lua/"
local quotes = read_quotes_from_json(root .. "quotes.json")

local pids = {}

local M = {}


local function notify_quote(quote)
    notify(quote.content, "info", {
        title = quote.title,
        timeout = 1 * 60 * 1000,  -- last for 1 minutes
    })

    --- Check if sound path is present and valid
    if quote.path and #quote.path > 0 then
        local sound_path = root .. "audio/" .. quote.path[math.random(#quote.path)]
        local command = string.format("ffplay -nodisp -autoexit -volume %d '%s' > /dev/null 2>&1 & echo $!", volume, sound_path)
        -- os.execute(command)
        local handle = io.popen(command)
        local pid = handle:read("*a")
        handle:close()
        table.insert(pids, pid)
    end
end

-- Function to send a random quote
function M.send()
    if #quotes == 0 then
        print("No quotes available")
        return
    end
    local quote = quotes[math.random(#quotes)]

    --- Execute the VBScript command
    os.execute([[cmd.exe /c cscript.exe "c:\\Users\\Shinku\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\PulseAudio.vbs" > /dev/null 2>&1 &]])
    vim.defer_fn(function()
        notify_quote(quote)
    end, 1500)
end


-- Function to schedule sending quotes
local function schedule_quote()
    local interval = math.random(5, 20)  -- Random time between 5 and 20 minutes
    vim.defer_fn(function()
        M.send()
        schedule_quote()  -- Schedule the next quote
    end, interval * 60 * 1000)  -- Convert seconds to milliseconds
end

-- Start the schedule
schedule_quote()

vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        for _, pid in ipairs(pids) do
            os.execute("kill -9 " .. pid)
        end
    end
})


return M
