#!/usr/bin/env ruby
require 'json'

module GeoJsonHelper
  def self.coordinates_to_geojson(coordinates)
    coordinates.map do |coord|
      formatted_coord = [coord.lon, coord.lat]
      formatted_coord.push(coord.ele) if coord.ele
      formatted_coord
    end
  end

def self.feature_to_geojson(type, geometry, properties = {})
  {
    type: 'Feature',
    properties: properties.compact,
    geometry: geometry
}.to_json
end
end

class TrackSegment
  attr_reader :coordinates

  def initialize(coordinates)
    @coordinates = coordinates
  end

  def coordinates_to_geojson
    GeoJsonHelper.coordinates_to_geojson(@coordinates)
  end
end

class Track
  def initialize(segments, name = nil)
    @name = name
    @segments = segments.map { |segment| TrackSegment.new(segment) }
  end

  def to_geojson
    coordinates = @segments.map(&:coordinates_to_geojson)
    properties = { title: @name }.compact
    geometry = { type: 'MultiLineString', coordinates: coordinates }

    GeoJsonHelper.feature_to_geojson('Feature', geometry, properties)
  end
end

class Point
  attr_reader :lat, :lon, :ele

  def initialize(lon, lat, ele = nil)
    @lon = lon
    @lat = lat
    @ele = ele
  end

  def to_geojson
    geometry = {
      type: 'Point',
      coordinates: [@lon, @lat, @ele].compact
    }

    GeoJsonHelper.feature_to_geojson('Feature', geometry, {})
  end
end

class Waypoint < Point
  attr_reader :name, :type

  def initialize(lon, lat, ele = nil, name = nil, type = nil)
    super(lon, lat, ele)
    @name = name
    @type = type
  end

  def to_geojson
    geometry = {
      type: 'Point',
      coordinates: [@lon, @lat, @ele].compact
    }

    properties = { title: @name, icon: @type }.compact
    GeoJsonHelper.feature_to_geojson('Feature', geometry, properties)
  end
end

class World
  def initialize(name, features = [])
    @name = name
    @features = features
  end

  def add_feature(feature)
    @features << feature
  end

  def to_geojson
    features_geojson = @features.map { |feature| JSON.parse(feature.to_geojson) }
    {
      type: 'FeatureCollection',
      features: features_geojson
    }.to_json
  end
end

def main
  waypoint_1 = Waypoint.new(-121.5, 45.5, 30, "home", "flag")
  waypoint_2 = Waypoint.new(-121.5, 45.6, nil, "store", "dot")

  track_seg_1 = [
    Point.new(-122, 45),
    Point.new(-122, 46),
    Point.new(-121, 46)
  ]
  
  track_seg_2 = [
    Point.new(-121, 45),
    Point.new(-121, 46)
  ]
  
  track_seg_3 = [
    Point.new(-121, 45.5),
    Point.new(-122, 45.5)
  ]

  track_1 = Track.new([track_seg_1, track_seg_2], "track 1")
  track_2 = Track.new([track_seg_3], "track 2")

  world = World.new("My Data", [waypoint_1, waypoint_2, track_1, track_2])
  puts world.to_geojson
end

if __FILE__ == $0
  main
end
