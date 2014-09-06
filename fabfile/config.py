# TODO This module should load 'config.yaml' from the above directory and store
# it for queries by tasks.

def get(path):
    return {}


def merge(*paths):
    result = {}
    for path in paths:
        result.update(get(path))

    return result
