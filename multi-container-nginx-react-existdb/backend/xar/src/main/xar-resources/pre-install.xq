xquery version "3.1";
(:
Module Name: 

Module Version: 1.0

Date: May 17, 2019

Copyright (c) 2019. EasyMetaHub, LLC

Proprietary
Extensions: eXist-db

XQuery
Specification March 2017

Module Overview: 

 :)
(:~
This script will be executed before your application
is copied into the database.

You can perform any additional initialisation that you
need in here. By default it just installs your
collection.xconf.

The following external variables are set by the repo:deploy function

@author Loren Cahlander
@since May 17, 2019
@version 1.0
 :)


import module namespace xmldb = "http://exist-db.org/xquery/xmldb";
import module namespace sm = "http://exist-db.org/xquery/securitymanager";

(:~ file path pointing to the exist installation directory :)
declare variable $home external;

(:~ path to the directory containing the unpacked .xar package :)
declare variable $dir external;

(:~ the target collection into which the app is deployed :)
declare variable $target external;


declare function local:mkcol-recursive($collection, $components) {
    if (exists($components)) then
        let $newColl := concat($collection, "/", $components[1])
        return
            (
            xmldb:create-collection($collection, $components[1]),
            local:mkcol-recursive($newColl, subsequence($components, 2))
            )
    else
        ()
};

(:~ Helper function to recursively create a collection hierarchy. :)
declare function local:mkcol($collection, $path) {
    local:mkcol-recursive($collection, tokenize($path, "/"))
};

(: Store the startup script to reschedule all of the tasks in the application
if (xmldb:collection-available("/db/system/autostart"))
then ()
else (
    xmldb:create-collection("/db/system", "autostart"),
    sm:chown(xs:anyURI("/db/system/autostart"), "admin"),
    sm:chgrp(xs:anyURI("/db/system/autostart"), "dba"),
    sm:chmod(xs:anyURI("/db/system/autostart"), "rwxrwx---")
    ()
),:)
(: store the collection configuration :)
local:mkcol("/db/system/config", $target),
xmldb:store-files-from-pattern(concat("/system/config", $target), $dir, "collection.xconf")
