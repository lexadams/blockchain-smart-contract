contract('WillTest', function (accounts) {
  it("should assert true", function (done) {
    var will_test = WillTest.deployed();
    assert.isTrue(true);
    done();
  });
});
