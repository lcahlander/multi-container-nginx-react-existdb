xquery version "3.1";
(:
Module Name: RestXQ APIs

Module Version: 1.0

Date: January 29, 2021

Copyright (c) 2021. EasyMetaHub, LLC

Proprietary
Extensions: eXist-db

XQuery
Specification March 2017

Module Overview:

 :)
(:~
This is the function module with the micro services API calls are defined.

@author Loren Cahlander
@since January 29, 2021
@version 1.0
 :)
module namespace login = "http://exist-db.org/example/modules/ns/login";

(:
import module namespace jwt = "http://exist-db.org/security/jwt/xquery"
    at "java:org.exist.security.realm.jwt.xquery.JWTModule";
:)

declare function login:authenticate($authorization as xs:string?)
as empty-sequence()
{
    if ($authorization)
    then
        if (fn:starts-with($authorization, "Bearer"))
        then () (:jwt:authorize($authorization):)
        else ()
    else ()

};
