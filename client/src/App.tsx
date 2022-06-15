import React, { useState, useEffect } from 'react';
import { Route, Routes } from "react-router-dom";
import Layout from "./Layout";
import { base_url } from './constants'
import { UserObject } from "./DataTypes";
import Userinfo from "./UserInfo/UserInfo";

function App() {
    const [userData, setUserData] = useState<UserObject>({id: '', description: '', groups:[]});

    useEffect(() => {
        fetch(base_url + '/exist/restxq/example/who-am-i')
            .then(res => res.json())
            .then(
                (result) => {
                    console.log(result);
                    setUserData(result);
                },
                // Note: it's important to handle errors here
                // instead of a catch() block so that we don't swallow
                // exceptions from actual bugs in components.
                (error) => {
                    setUserData({id: '', description: '', groups:[{id: '', description: ''}]});
                }
            )

    }, [])
  return (
        <Routes>
          <Route path="/" element={<Layout user={userData} />}>
              <Route path="user" element={<Userinfo user={userData} />} />

          </Route>
        </Routes>
  );
}

export default App;
