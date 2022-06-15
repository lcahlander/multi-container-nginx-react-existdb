import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css';
import React from "react";
import SideBar from "./SideBar";
import MagellanContent from "./MagellanContent";
import { UserObject } from "./DataTypes";

interface Props {
    user: UserObject
}

export default function Layout(props:Props) {

        return (
            <div className={'App'}>
                <SideBar user={props.user} />
                <MagellanContent user={props.user} />
            </div>
        );
}