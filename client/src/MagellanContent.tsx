import 'bootstrap/dist/css/bootstrap.min.css';
import React from "react";
import './App.css';
import { UserObject } from "./DataTypes";
import {Outlet} from "react-router";

interface Props {
    user: UserObject
}

function MagellanContent(props:Props) {
    return (
        <div className={'MagellanContent'}>
            <Outlet />
        </div>
    )
}

export default MagellanContent;