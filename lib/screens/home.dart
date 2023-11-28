import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/services/location_provider.dart';
import 'package:weatherapp/services/weather_service_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePOsition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });
    // Provider.of<LocationProvider>(context, listen: false).determinePOsition();
    // Provider.of<WeatherServiceProvider>(context, listen: false)
    //     .fetchWeatherDataByCity("dubai");
    super.initState();
  }

  TextEditingController cityController = TextEditingController();
  var city;
  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherServiceProvider>(context);
    Size size = MediaQuery.of(context).size;

    // Get the sunrise timestamp from the API response

    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ?? 0;
// Convert the timestamp to a DateTime object
    DateTime sunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

// Format the sunrise time as a string
    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(),
        body: Container(
            height: size.height,
            width: size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/sunrisebg.jpg'))),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 0, 0),
                child: Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) {
                  String? locationCity;
                  if (locationProvider.currentLocationName != null) {
                    locationCity =
                        locationProvider.currentLocationName!.locality;
                  } else {
                    locationCity = "Unknown Location";
                  }
                  return Column(children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locationCity!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 160,
                          child: TextFormField(
                            controller: cityController,
                            decoration: const InputDecoration(
                                hintText: "Search",
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              weatherProvider
                                  .fetchWeatherDataByCity(cityController.text);
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Image.asset(
                      "assets/images/sun.png",
                      width: 200,
                      height: 170,
                    ),
                    SizedBox(
                      height: 130,
                      width: 180,
                      child: Column(
                        children: [
                          Text(
                            "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0) ?? 'N/A'}\u00B0C",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          Text(weatherProvider.weather?.name ?? "N/A",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20)),
                          Text(
                              weatherProvider.weather?.weather?[0].main ??
                                  "N/A",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20)),
                          Text(DateFormat("hh:mm a").format(DateTime.now()))
                        ],
                      ),
                    ),
                    Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            "assets/images/hightemp.png",
                                            height: 40),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Temp Max"),
                                              Text(
                                                  "${weatherProvider.weather?.main?.tempMax?.toStringAsFixed(0) ?? 'N/A'}\u00B0 C")
                                            ])
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/images/lowtemp.png",
                                              height: 40),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Temp Min"),
                                                Text(
                                                    "${weatherProvider.weather?.main?.tempMin?.toStringAsFixed(0) ?? 'N/A'}\u00B0 C")
                                              ])
                                        ])
                                  ]),
                              const Divider(
                                  indent: 20,
                                  endIndent: 20,
                                  color: Colors.white,
                                  thickness: 1),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              "assets/images/sunrise.png",
                                              height: 40),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Sun Rise"),
                                                Text(formattedSunrise)
                                              ])
                                        ]),
                                    const SizedBox(width: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/images/moon.png",
                                              height: 40),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Sun Set"),
                                                Text(formattedSunset)
                                              ])
                                        ])
                                  ])
                            ])),
                  ]);
                }))));
  }
}
