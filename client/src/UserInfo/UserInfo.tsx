import React from 'react';
import { UserObject } from "../DataTypes";
import {Card, ListGroup, ListGroupItem} from "react-bootstrap";
import { JSONTree } from 'react-json-tree';

export type UserinfoProps = {
    user: UserObject
}

export default function Userinfo({user}: UserinfoProps) {

    const theme =  {
        scheme: 'default',
        author: 'chris kempson (http://chriskempson.com)',
        base00: '#181818',
        base01: '#282828',
        base02: '#383838',
        base03: '#585858',
        base04: '#b8b8b8',
        base05: '#d8d8d8',
        base06: '#e8e8e8',
        base07: '#f8f8f8',
        base08: '#ab4642',
        base09: '#dc9656',
        base0A: '#f7ca88',
        base0B: '#a1b56c',
        base0C: '#86c1b9',
        base0D: '#7cafc2',
        base0E: '#ba8baf',
        base0F: '#a16946'
    };


    return (
        <div className="UserInfo">
            <h1>User</h1>
            <p>{user.id}</p>
            <p>{user.description}</p>
            <Card>
                <Card.Header>Groups</Card.Header>
                <ListGroup>{
                    user.groups.map((d) => {
                        return <ListGroupItem key={d.id}>{d.id} - {d.description}</ListGroupItem>
                    })
                }</ListGroup>
            </Card>
            <JSONTree data={user} theme={theme} />
        </div>
    );
}
