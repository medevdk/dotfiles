-- ~/.config/nvim/lua/plugins/gen.lua

return {
	"David-Kunz/gen.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = { "Gen" },
	opts = {
		model = "qwen2.5-coder:14b",
		host = "localhost",
		port = "11434",
		display_mode = "float",
		show_prompt = false,
		show_model = true,
		no_auto_close = false,
		hidden = false,
	},
	config = function(_, opts)
		local gen = require("gen")
		gen.setup(opts)

		---------------------------------------------------------------------------
		-- Custom Prompts for Go, Templ, HTMX, Tailwind v4, & Alpine.js
		---------------------------------------------------------------------------
		gen.prompts["Review_Stack_Context"] = {
			prompt = "Review the following $filetype snippet. Ensure idiomatic Go design pattern integration, proper typed attributes if it's a Templ file, and seamless htmx (hx-*) attribute usage. "
				.. "We use Tailwind CSS v4 and Alpine.js for frontend behaviors. Fix any syntax errors or bad patterns:\n```$filetype\n$text\n```",
			replace = false,
		}

		gen.prompts["Generate_Component"] = {
			prompt = "Generate a component based on this instruction: $input.\n"
				.. "Target Stack Rules:\n"
				.. "- Backend: Go + Templ templates.\n"
				.. "- State/Interactions: HTMX for server roundtrips, Alpine.js for local/client state.\n"
				.. "- Styling: Pure Tailwind CSS v4 markup.\n"
				.. "Only output the valid source block code, no conversational filler.",
			replace = true,
			extract = "```$filetype\n(.-)```",
		}

		gen.prompts["Deep_Reasoning"] = {
			prompt = "Analyze this complex implementation scenario: $input\n"
				.. "Context code:\n```$filetype\n$text\n```\n"
				.. "Think step-by-step about how to cleanly separate concerns across Go handlers, database operations, Templ layout components, and hx-swap targets.",
			replace = false,
		}

		gen.prompts["Analyze_Project_Structure"] = {
			prompt = function()
				local handle =
					io.popen("tree -I '.git|node_modules|bin|dist' 2>/dev/null || find . -maxdepth 3 -not -path '*/.*'")
				local structure = handle:read("*a")
				handle:close()

				return "Analyze the following project directory structure and explain how the layout handles architectural separation. "
					.. "Specifically, look at where the Go backend handlers, Templ markup templates, and assets sit. "
					.. "Provide recommendations on where to add new endpoints or HTMX client components cleanly:\n\n"
					.. "```text\n"
					.. structure
					.. "\n```\n\n"
					.. "Additional context or specific question: $input"
			end,
			replace = false,
		}
	end,
}
