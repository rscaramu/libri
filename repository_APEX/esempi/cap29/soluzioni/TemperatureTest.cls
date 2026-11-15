@IsTest
private class TemperatureTest {

    @IsTest
    static void converteInFahrenheit() {
        Assert.areEqual(68.0,
            Temperature.inFahrenheit(20));
        Assert.areEqual(32.0, Temperature.inFahrenheit(0));
        Assert.areEqual(14.0,
            Temperature.inFahrenheit(-10));
    }

    @IsTest
    static void converteInCelsius() {
        Assert.areEqual(37.0, Temperature.inCelsius(98.6));
        Assert.areEqual(-40.0, Temperature.inCelsius(-40));
    }
}
