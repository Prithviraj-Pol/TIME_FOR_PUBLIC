# TODO - Geofencing upgrade

- [ ] Inspect existing geofence implementation (completed: `backend/app/geofence.py` only has distance helper)
- [x] Implement circular geofence logic in `backend/app/geofence.py`
  - [x] Add `is_point_inside_circle(...)` using Haversine distance
  - [x] Add small helpers / validation (optional)

- [ ] (Optional) Wire into `backend/app/main.py` later if user wants API endpoints
- [ ] Run a quick local import/test command (if desired)

