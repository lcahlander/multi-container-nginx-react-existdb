import React from "react";
import './App.css';
import packageJson from "../package.json";
import {SideBarData} from "./SideBarData";
import TreeMenu from "react-simple-tree-menu";
import { useNavigate, useLocation } from "react-router-dom";
import '../node_modules/react-simple-tree-menu/dist/main.css';
import { UserObject } from "./DataTypes";

interface Props {
    user: UserObject
}

function SideBar(props:Props) {
    let navigate = useNavigate();
    let location = useLocation();
    return (
        <div className={'SideBar'}>
            <ul className={'SideBarList'}>
                <li key={-1} className={'toprow'}>
                    <div id={'icon'}>
                        <img
                            id="icon"
                            alt="Logo"
                            src="logo.png"
                            style={{height: 30, marginLeft: 15}}
                            className="d-inline-block align-top"
                        />
                    </div>
                    {' '}
                    <div id={'title'}>
                        <div style={{fontSize: "24px"}}>Sample</div>
                        <div style={{fontSize: "8px"}}>Version {packageJson.version}</div>
                    </div>
                </li>
            </ul>
            <TreeMenu
                data={SideBarData}
                activeKey={location.pathname}
                onClickItem={({ key, label, ...props }) => {
                    navigate(key);
                }}
                hasSearch={false}
            />
        </div>
    )
}

export default SideBar;