return function ()
    local HttpService = game:GetService("HttpService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local callTo = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("callTo"))
	local fake = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("fake"))
	local internalsSymbol = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("internalsSymbol"))
	local valueGeneratorCallback = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("valueGeneratorCallback"))

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
			expect(fakedTable(false, 0, "no")).to.never.be.ok()
		end)

		it("should return tuples as expected", function ()
			local fakedTable = fake()

			callTo(fakedTable, true):returns(1, "two")

			local correctArgsReturnValues = table.pack(fakedTable(true))
			expect(#correctArgsReturnValues).to.equal(2)
			expect(correctArgsReturnValues[1]).to.equal(1)
			expect(correctArgsReturnValues[2]).to.equal("two")

			expect(fakedTable(false)).to.never.be.ok()
		end)

		it("should return values from a value generator callback as expected", function ()
			local fakedTable = fake()

			local valueGeneratorCallbackCallCount = 0

			callTo(fakedTable, true):returns(valueGeneratorCallback(function ()
				valueGeneratorCallbackCallCount = valueGeneratorCallbackCallCount + 1
				return {}
			end))

			local firstCallResult = fakedTable(true)
			expect(firstCallResult).to.be.ok()
			expect(valueGeneratorCallbackCallCount).to.equal(1)

			local secondCallResult = fakedTable(true)
			expect(secondCallResult).to.be.ok()
			expect(valueGeneratorCallbackCallCount).to.equal(2)

			expect(firstCallResult).never.to.equal(secondCallResult)

			local mismatchedArgsCallResult = fakedTable(false)
			expect(mismatchedArgsCallResult).to.never.be.ok()
			expect(valueGeneratorCallbackCallCount).to.equal(2)
		end)

		it("should put newest call matches at the front of the fakedTable's callBehaviors array", function ()
			local fakedTable = fake()

			expect(#fakedTable[internalsSymbol]["callBehaviors"]).to.equal(0)

			callTo(fakedTable, true):executes(function () end)
			expect(#fakedTable[internalsSymbol]["callBehaviors"]).to.equal(1)
			expect(fakedTable[internalsSymbol]["callBehaviors"][1]["invoke"]).to.be.ok()

			callTo(fakedTable, true):returns("return value")
			expect(#fakedTable[internalsSymbol]["callBehaviors"]).to.equal(2)
			expect(fakedTable[internalsSymbol]["callBehaviors"][1]["returnValueGetter"]).to.be.ok()

			callTo(fakedTable, true):throws("thrower")
			expect(#fakedTable[internalsSymbol]["callBehaviors"]).to.equal(3)
			expect(fakedTable[internalsSymbol]["callBehaviors"][1]["throw"]).to.be.ok()
		end)

		it("should be able to chain call behaviors with andThen", function ()
			local fakedTable = fake()

			local originalCallMatch = callTo(fakedTable, true)

			local callMatchAfterExecutes = originalCallMatch:executes(function () end).andThen
			expect(callMatchAfterExecutes).to.equal(originalCallMatch)

			local callMatchAfterReturns = originalCallMatch:returns("return value").andThen
			expect(callMatchAfterReturns).to.equal(originalCallMatch)

			local callMatchAfterThrows = originalCallMatch:throws("thrower").andThen
			expect(callMatchAfterThrows).to.equal(originalCallMatch)
		end)

		it("should set numberOfRemainingUses properly", function ()
			local fakedTable = fake()

			expect(#fakedTable[internalsSymbol]["callBehaviors"]).to.equal(0)

			local callMatch = callTo(fakedTable, true)

			callMatch = callMatch:returns("return value").andThen
			expect(#fakedTable[internalsSymbol]["callBehaviors"]).to.equal(1)
			expect(fakedTable[internalsSymbol]["callBehaviors"][1]["numberOfRemainingUses"]).to.equal(-1)

			callMatch = callMatch:executes(function () end):once().andThen
			expect(#fakedTable[internalsSymbol]["callBehaviors"]).to.equal(2)
			expect(fakedTable[internalsSymbol]["callBehaviors"][1]["numberOfRemainingUses"]).to.equal(1)

			callMatch = callMatch:returns("return value again"):twice().andThen
			expect(#fakedTable[internalsSymbol]["callBehaviors"]).to.equal(3)
			expect(fakedTable[internalsSymbol]["callBehaviors"][1]["numberOfRemainingUses"]).to.equal(2)

			local randomCallsValue = math.random(10, 20)
			callMatch = callMatch:throws("thrower"):numberOfTimes(randomCallsValue).andThen
			expect(#fakedTable[internalsSymbol]["callBehaviors"]).to.equal(4)
			expect(fakedTable[internalsSymbol]["callBehaviors"][1]["numberOfRemainingUses"]).to.equal(randomCallsValue)
		end)
	end)
end
