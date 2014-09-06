from . import config
from fabric.api import *


@task
def create(name, tag):
    '''
    Creates a new deployment stack based on tag.

    Will trigger the images.build and images.upload tasks if needed.
    '''
    conf = config.merge('stacks.common', 'stacks.%s' % name)
    print 'creating', name, 'stack as', tag, 'with', conf


@task
def update(name, tag):
    '''
    Updates a deployed stack to a new tag.

    Will trigger the images.build and images.upload tasks if needed.
    '''
    print 'updating', name, 'stack to', tag


@task
def delete(name):
    '''
    Deletes a deployed stack.
    '''
    print 'deleting', name, 'stack'
