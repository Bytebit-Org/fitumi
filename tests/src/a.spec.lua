return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local a = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("a"))

	describe("fitumi entry", function()
		it("should provide the expected key/value pairs", function()
			expect(a.callTo).to.be.a("function")
			expect(a.fake).to.be.a("function")
			expect(a.valueGeneratorCallback).to.be.a("function")
			expect(a.writeTo).to.be.a("function")
		end)
	end)
end
