from . import config
from fabric.api import *


@task(name='get-ids')
def get_ids(tag):
    '''
    Returns a dictionary of uploaded service image ids for a given tag.
    '''
    print 'getting OS image ids for tag', tag


@task(name='get-unrelated-ids')
def get_unrelated_ids(*tags):
    '''
    Returns a list of PTero service image ids not associated with tags.
    '''
    print 'getting OS image ids not related to', tags


@task(name='delete-unrelated')
def delete_unrelated(*tags):
    '''
    Delete all PTero service image not associated with tags.
    '''
    print 'deleting images unrelated to', tags

@task
def build(tag):
    '''
    Builds (and downloads) service images for a given tag.
    '''
    print 'building images for', tag, 'with', config.get('images.build')


@task
def upload(tag):
    '''
    Uploads already-built service images for a given tag.
    '''
    print 'uploading images for', tag
