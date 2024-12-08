## Summary of Changes

	I refactored the code by moving the GeoJSON formatting into a GeoJsonHelper module, to apply the DRY principle. I used descriptive names, and used JSON serialization to align the code with the SRP. I applied Encapsulation by adding a coordinate formatter to TrackSegment to comply with the Law of Demeter, and used Dependency injection to keep the code flexible.


## GIS Tool

Geographic Information Systems program.

This is a tool to work with geographic data. It takes a number of
geographic entities (Waypoints, Tracks) as input, and outputs them in a
standard format called GeoJSON.

Unfortunately, the tool (even though it works) suffers from bad
engineering. You should fix it up and eliminate that technical debt.

### Things to Watch For!

* Don't Repeat Yourself (DRY) violations--common code, potential
  subclassing.

* Single Responsibility Principle (SRP) violations

* Law of Demeter (LOD) violations.

* Places where Dependency Injection (DI) can reduce coupling.

* Bad variable names.

* Senseless comments.

* Places common interfaces can help.

Also:

* Make the code look good! Does it read easily?

## Running

You should be able to run it already:

```
ruby gis.rb
```

This will give GeoJSON output for some features that have been added in
the code:

```
{"type":"FeatureCollection","features":[{"type": "Feature","properties":
{"title": "home","icon": "flag"},"geometry":{"type":"Point","coordinates
":[-121.5,45.5,30]}},{"type": "Feature","properties": {"title": "store",
"icon": "dot"},"geometry":{"type":"Point","coordinates":[-121.5,45.6]}},
{"type": "Feature","properties": {"title": "track 1"},"geometry": {"type
": "MultiLineString","coordinates": [[[45,-122],[46,-122],[46,-121]],[[4
5,-121],[46,-121]]]}},{"type": "Feature","properties": {"title": "track 
2"},"geometry": {"type": "MultiLineString","coordinates": [[[45.5,-121],
[45.5,-122]]]}}]}
```

If you pipe it into the program `json_print.rb`, it should pretty
it up for you:

```
ruby gis.rb | ruby json_print.rb
```

**If the above command fails with an error in `parse`, it means the JSON
is malformed and needs to be fixed.**

(See the example at the bottom for sample output from this command.)

## Testing

You can run some unit tests with:

```
ruby tc_gis.rb
```

These tests depend on the method names, so if you change those, be sure
to change them in the tests, too.

The tests convert the JSON strings to Ruby hashes for the comparison so
it should work even if the order of elements in the JSON is changed.

## What to Do

1. Fork this repo. Clone your fork to your computer.

2. Refactor the code so that it follows the principles introduced this
   quarter. Anything in the code can be changed, but the output should
   remain the same.

   ALSO: Maintain a summary list of the changes that you made at the top
   of this README!

3. Commit and push your fork.

4. Submit a link to your fork.

## Hints

* **UNDERSTAND THE CODE AND THE PROBLEM BEFORE YOU START!**

* Make small changes.

* **Test the code at every change.** See the note about running unit
  tests, above.

* If the change works, commit it.

* If the change doesn't work, figure out what's amiss or roll back the
  previous commit.

* You can get a diff from the previous commit with:
  ```
  git diff
  ```

* You can revert uncommitted changes to the previous commit.
  **WARNING: this unceremoniously destroys any changes to the file
  you've made since the last commit!**

  ```
  git checkout gis.rb
  ```

* Though not required, the `json` module might be useful.

* The JSON must be valid. It can have extraneous whitespace or different
  formatting, but it must parse.

## About GeoJson

### Data Representation

* Latitude, longitude: these are decimal degrees (no minutes or
  seconds). West is negative latitude. South is negative longitude.

  Example: Bend, Oregon is at longitude -121.3, latitude 44.05

* Elevation: given in meters above sea level.

### Data Types

There are three types of data you can represent:

* **Waypoint**: This is a point represented by a latitude, longitude,
  and optional elevation. A waypoint also has an optional _name_ and
  _icon_. (e.g. a name might be "ACME Dining" and the icon might be
  "restaurant".)

* **Track Segment**: This is a list of latitude/longitude pairs (with
  optional elevation). The points of a Track Segment do not have names
  or icons. The Track Segment represents a section of a Track.

* **Track**: This is a list of Track Segments. It has an optional
  _name_.

### GeoJSON Format

Look at the example in the next section for context. Make sure you can
match up the following with that example before proceeding.

The GeoJSON file is an object with two fields:

* `"type"` is `"FeatureCollection"`
* `"features"` is an array of features

The features are objects with three fields:

* `"type"` is `"Feature"`
* `"properties"` is an object that contains additional properties
* `"geometry"` is an object that defines the shape of the feature

The geometry objects contain two fields:

* `"type"` is either `"Point"` for a single point, or
  `"MultiLineString"` for tracks
* `"coordinates"` are the coordinates that define the object. This is a
  single longitude/latitude/elevation for Points. It is an array of
  arrays of points for MultiLineStrings.

### Example GeoJSON File

```json
{
    "type":"FeatureCollection",
    "features":[
        {
            "type":"Feature",
            "properties":{
                "title":"home",
                "icon":"flag"
            },
            "geometry":{
                "type":"Point",
                "coordinates":[ -121.5, 45.5, 30 ]
            }
        },
        {
            "type":"Feature",
            "properties":{
                "title":"store",
                "icon":"dot"
            },
            "geometry":{
                "type":"Point",
                "coordinates":[ -121.5, 45.6 ]
            }
        },
        {
            "type":"Feature",
            "properties":{
                "title":"track 1"
            },
            "geometry":{
                "type":"MultiLineString",
                "coordinates":[
                    [
                        [ -122, 45 ], [ -122, 46 ], [ -121, 46 ]
                    ],
                    [
                        [ -121, 45 ], [ -121, 46 ]
                    ]
                ]
            }
        },
        {
            "type":"Feature",
            "properties":{
                "title":"track 2"
            },
            "geometry":{
                "type":"MultiLineString",
                "coordinates":[
                    [
                        [ -121, 45.5 ], [ -122, 45.5 ]
                    ]
                ]
            }
        }
    ]
}
```
