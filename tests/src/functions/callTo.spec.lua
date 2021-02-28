return function ()
    local HttpService = game:GetService("HttpService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local callTo = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("callTo"))
	local fake = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("fake"))
	local internalsSymbol = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("internalsSymbol"))

	describe("callTo", function ()
		it("should return the expected set of methods", function ()
			local fakedTable = fake()

			local result = callTo(fakedTable)
			expect(result).to.be.ok()
			expect(result).to.be.a("table")
			expect(result["executes"]).to.be.a("function")
			expect(result["didHappen"]).to.be.a("function")
			expect(result["didNotHappen"]).to.be.a("function")
			expect(result["throws"]).to.be.a("function")
			expect(result["returns"]).to.be.a("function")
		end)

		it("should error when given an invalid input", function ()
			expect(function ()
				callTo(nil)
			end).to.throw()
			expect(function ()
				callTo(false)
			end).to.throw()
			expect(function ()
				callTo(true)
			end).to.throw()
			expect(function ()
				callTo(0)
			end).to.throw()
			expect(function ()
				callTo(1)
			end).to.throw()
			expect(function ()
				callTo(math.huge)
			end).to.throw()
			expect(function ()
				callTo("hello, world")
			end).to.throw()
			expect(function ()
				callTo(function () end)
			end).to.throw()
			expect(function ()
				callTo({})
			end).to.throw()
		end)

		it("should execute callbacks as expected", function ()
			local fakedTable = fake()

			local executionCount = 0
			callTo(fakedTable, true):executes(function ()
				executionCount = executionCount + 1
			end)

			fakedTable(true)
			expect(executionCount).to.equal(1)

			fakedTable(false)
			expect(executionCount).to.equal(1)
		end)

		it("should report that a call happened correctly", function ()
			local fakedTable = fake()

			fakedTable(true, 2, "three")

			expect(callTo(fakedTable):didHappen()).to.equal(false)
			expect(callTo(fakedTable, true):didHappen()).to.equal(false)
			expect(callTo(fakedTable, true, 2):didHappen()).to.equal(false)
			expect(callTo(fakedTable, true, 2, "three"):didHappen()).to.equal(true)
		end)

		it("should report that a call did not happen correctly", function ()
			local fakedTable = fake()

			fakedTable(true, 2, "three")

			expect(callTo(fakedTable):didNotHappen()).to.equal(true)
			expect(callTo(fakedTable, true):didNotHappen()).to.equal(true)
			expect(callTo(fakedTable, true, 2):didNotHappen()).to.equal(true)
			expect(callTo(fakedTable, true, 2, "three"):didNotHappen()).to.equal(false)
		end)

		it("should enforce throws as expected", function ()
			local fakedTable = fake()

			local errorMessage = HttpService:GenerateGUID()
			callTo(fakedTable):throws(errorMessage)

			expect(fakedTable).to.throw(errorMessage)
		end)

		it("should enforce return values as expected", function ()
			local fakedTable = fake()

			local returnValue = {}
			callTo(fakedTable, true, 2, "three"):returns(returnValue)

			expect(fakedTable(true, 2, "three")).to.equal(returnValue)
			expect(fakedTable(false, 0, "no")).never.to.be.ok()
		end)

		it("should return tuples as expected", function ()
			local fakedTable = fake()

			callTo(fakedTable, true):returns(1, "two")

			local correctArgsReturnValues = table.pack(fakedTable(true))
			expect(#correctArgsReturnValues).to.equal(2)
			expect(correctArgsReturnValues[1]).to.equal(1)
			expect(correctArgsReturnValues[2]).to.equal("two")

			expect(fakedTable(false)).never.to.be.ok()
		end)
	end)
end
