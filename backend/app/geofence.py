import math
from dataclasses import dataclass


def get_distance_meters(lat1, lon1, lat2, lon2):
    """Great-circle distance between two lat/lng points using the Haversine formula."""
    # Radius of Earth in kilometers
    R = 6371.0

    # Convert degrees to radians
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    dphi = math.radians(lat2 - lat1)
    dlambda = math.radians(lon2 - lon1)

    # Haversine calculation
    a = math.sin(dphi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) ** 2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    distance_km = R * c
    return distance_km * 1000  # Convert to meters


@dataclass(frozen=True)
class GeofenceCircle:
    """Circular geofence defined by a center point and radius (in meters)."""

    center_lat: float
    center_lng: float
    radius_m: float

    def contains(self, point_lat: float, point_lng: float) -> bool:
        """Return True if the point is inside (or on the border) of this geofence."""
        if self.radius_m < 0:
            raise ValueError("radius_m must be >= 0")

        distance_m = get_distance_meters(
            self.center_lat,
            self.center_lng,
            point_lat,
            point_lng,
        )
        return distance_m <= self.radius_m


def is_point_inside_circle(
    point_lat: float,
    point_lng: float,
    center_lat: float,
    center_lng: float,
    radius_m: float,
) -> bool:
    """Convenience function for circular geofencing."""
    return GeofenceCircle(center_lat=center_lat, center_lng=center_lng, radius_m=radius_m).contains(
        point_lat,
        point_lng,
    )

