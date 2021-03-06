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

@author Loren Cahlander
@since May 17, 2019
@version 1.0
 :)
module namespace whoami = "http://exist-db.org/modules/ns/who-am-i";

import module namespace sm = "http://exist-db.org/xquery/securitymanager";
import module namespace jwtd = "https://exist-db.org/exist-db/ns/jwtd";


declare namespace rest="http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace map= "http://www.w3.org/2005/xpath-functions/map";

(:~
Get the details of the current user.
@param $jwt The authorization token for RBAC
@return
@custom:openapi-tag Security
 :)
declare
    %rest:GET
    %rest:path("/example/who-am-i")
    %rest:header-param("JWT", "{$jwt}")
    %rest:produces("application/json")
    %output:media-type("application/json")
    %output:method("json")
function whoami:get(
                $jwt as xs:string*
)
as map(*)
{
    let $login :=
        try {
            xmldb:login("/db", $jwt || "@test", $jwt || "@test")
        } catch * {
        ()
        }

    let $names := map {
        "http://axschema.org/contact/email": "email",
        "http://axschema.org/pref/language": "language",
        "http://exist-db.org/security/description": "description",
        "http://axschema.org/contact/country/home": "country",
        "http://axschema.org/namePerson": "name",
        "http://axschema.org/namePerson/first": "firstname",
        "http://axschema.org/namePerson/friendly": "friendly",
        "http://axschema.org/namePerson/last": "lastname",
        "http://axschema.org/pref/timezone": "timezone"
    }

    let $id := sm:id()
    let $base := ($id//sm:effective, $id//sm:real)[1]

    let $user := $base/sm:username/text()
    let $groups := $base//sm:group/text()
    let $properties :=
        for $key in sm:get-account-metadata-keys()
        return
            if (fn:exists(sm:get-account-metadata($user, $key)))
            then map { map:get($names, $key) : sm:get-account-metadata($user, $key) }
            else ()
    return map:merge((
        try {
            map {
                "payload": fn:parse-json(jwtd:decode($jwt))
            }
        } catch * { () },
        map {
            "jwt": $jwt,
            "id" : $user,
            "groups" : array {
                for $group in  $groups
                let $name-map := map { "id" : $group }
                let $properties :=
                    for $key in sm:get-group-metadata-keys()
                    return
                        if (fn:exists(sm:get-group-metadata($group, $key)))
                        then map { map:get($names, $key) : sm:get-group-metadata($group, $key) }
                        else ()
                return  map:merge(($name-map, $properties))
            }
        },
        $properties))
};

(:~
Get the details of the current user.
@param $authorization The authorization token for RBAC
@return
@custom:openapi-tag Security
 :)
declare
    %rest:GET
    %rest:path("/example/who-am-i2")
    %rest:header-param("JWT", "{$jwt}")
function whoami:get2(
                $jwt as xs:string*
)
{
    let $login :=
        try {
            xmldb:login("/db", $jwt || "@test", $jwt || "@test")
        } catch * {
        ()
        }

    return sm:id()
};
