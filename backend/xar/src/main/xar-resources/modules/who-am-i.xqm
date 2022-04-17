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
import module namespace login = "http://exist-db.org/example/modules/ns/login";


declare namespace rest="http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace map= "http://www.w3.org/2005/xpath-functions/map";
declare namespace test="http://exist-db.org/xquery/xqsuite";

(:~
Get the details of the current user.
@param $authorization The authorization token for RBAC
@param $cookie1 The authorization as a cookie
@param $cookie2 The authorization as a cookie
@return
@custom:openapi-tag Security
 :)
declare
    %rest:GET
    %rest:path("/example/who-am-i")
    %rest:header-param("Authorization", "{$authorization}")
    %rest:cookie-param("auth1", "{$cookie1}")
    %rest:cookie-param("auth2", "{$cookie2}")
    %rest:produces("application/json")
    %output:media-type("application/json")
    %output:method("json")
function whoami:get(
                $authorization as xs:string*,
                $cookie1 as xs:string*,
                $cookie2 as xs:string*
)
as map(*)
{
    let $login := login:authenticate($authorization[1], $cookie1[1], $cookie2[1])

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
        map {
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
