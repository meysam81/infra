# Calculate Service Changes

This short snippet stores the previous state of the internal services and
checks whether the new git push has changed any of those services. In which
case it will trigger a `docker build` by passing the list of changed services
to a dynamic GitHub matrix, running in parallel to increase the throughput.
