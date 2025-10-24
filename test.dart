/// Decorator Pattern
abstract class Beverage {
  double cost();
}

abstract class Condiments implements Beverage {}

class Coffee implements Beverage {
  @override
  String toString() {
    return 'Coffee';
  }

  @override
  double cost() {
    return 1;
  }
}

class Caramel implements Condiments {
  final Beverage beverage;

  Caramel({required this.beverage});

  @override
  String toString() {
    return '${beverage.toString()}, Caramel';
  }

  @override
  double cost() {
    return beverage.cost() + 0.5;
  }
}

class Whip implements Condiments {
  final Beverage beverage;

  Whip({required this.beverage});

  @override
  String toString() {
    return '${beverage.toString()}, Whip';
  }

  @override
  double cost() {
    return beverage.cost() + .5;
  }
}

class Milk implements Condiments {
  final Beverage beverage;

  Milk({required this.beverage});

  @override
  String toString() => '${beverage.toString()}, Milk';

  @override
  double cost() => beverage.cost() + 2;
}

class StarBuzz {
  void start() {
    Beverage coffee = Coffee();
    print('Cost of ${coffee.toString()}: ${coffee.cost()} AED');

    final Beverage coffeeWithCaramel = Caramel(beverage: coffee);
    print('Cost of ${coffeeWithCaramel.toString()}: ${coffeeWithCaramel.cost()} AED');

    coffee = Whip(beverage: coffee);
    coffee = Whip(beverage: coffee);
    coffee = Milk(beverage: coffee);
    coffee = Caramel(beverage: coffee);

    print('Cost of ${coffee.toString()}: ${coffee.cost()} AED');
  }
}

/// Observer Pattern
abstract class Subject {
  void registerObserver(Observer observer);

  void removeObserver(Observer observer);

  void notifyObservers();
}

abstract class Observer {
  void update();
}

class WeatherData extends Subject {
  late double _temperature;
  late double _humidity;
  late double _pressure;
  late double? _windSpeed;

  double get temperature => _temperature;

  double get humidity => _humidity;

  double get pressure => _pressure;

  double? get windSpeed => _windSpeed;

  final List<Observer> _observers = [];

  void setMeasurements(
      {required double temperature, required double humidity, required double pressure, double? windSpeed}) {
    _temperature = temperature;
    _humidity = humidity;
    _pressure = pressure;
    _windSpeed = windSpeed;
    print('\n📡 WeatherData updated: T=$_temperature, H=$_humidity, P=$_pressure, W=$_windSpeed');
    notifyObservers();
  }

  @override
  void notifyObservers() {
    for (final observer in _observers) {
      observer.update();
    }
  }

  @override
  void registerObserver(Observer observer) {
    _observers.add(observer);
    print('${observer.runtimeType} registered.');
  }

  @override
  void removeObserver(Observer observer) {
    _observers.remove(observer);
    print('${observer.runtimeType} removed.');
  }
}

abstract class DisplayElement {
  void display();
}

class CurrentConditionsDisplay implements Observer, DisplayElement {
  final WeatherData weatherData;

  CurrentConditionsDisplay(this.weatherData) {
    weatherData.registerObserver(this);
  }

  late double _temperature;
  late double _humidity;

  @override
  void update() {
    _temperature = weatherData.temperature;
    _humidity = weatherData.humidity;
    display();
  }

  @override
  void display() {
    print('Current Conditions: ${_temperature}F degrees, $_humidity% humidity');
  }
}

class PressureDisplay implements Observer, DisplayElement {
  final WeatherData weatherData;

  PressureDisplay(this.weatherData) {
    weatherData.registerObserver(this);
  }

  late double _pressure;

  @override
  void update() {
    _pressure = weatherData.pressure;
    display();
  }

  @override
  void display() {
    print('Pressure Display: $_pressure');
  }
}

class WindDisplay implements Observer, DisplayElement {
  final WeatherData weatherData;

  WindDisplay(this.weatherData) {
    weatherData.registerObserver(this);
  }

  late double? _windSpeed;

  @override
  void update() {
    _windSpeed = weatherData.windSpeed;
    if (_windSpeed == null) return;
    display();
  }

  @override
  void display() {
    print('Wind speed: $_windSpeed km/h');
  }
}

class WeatherStation {
  void start() {
    final weatherData = WeatherData();
    final currentConditionsDisplay = CurrentConditionsDisplay(weatherData);
    final pressureDisplay = PressureDisplay(weatherData);
    final windDisplay = WindDisplay(weatherData);
    weatherData.setMeasurements(temperature: 25, humidity: 60, pressure: 105);
    weatherData.removeObserver(currentConditionsDisplay);
    weatherData.setMeasurements(temperature: 30, humidity: 70, pressure: 90, windSpeed: 10);
  }
}

void main() {
  final starBuzz = StarBuzz();
  starBuzz.start();

  final weatherStation = WeatherStation();
  weatherStation.start();
}
