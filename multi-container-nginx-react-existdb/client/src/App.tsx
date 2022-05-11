import React, { useState, useEffect } from 'react';
import packageJson from '../package.json';
import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css';
import {Card, ListGroup, ListGroupItem, Navbar} from "react-bootstrap";
import ReactJson from 'react-json-view'

function App() {
  const [userData, setUserData] = useState({id: '', description: '', groups:[{id: '', description: ''}]});

  useEffect(() => {
    fetch('/exist/restxq/example/who-am-i')
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
    <div className="App">
        <Navbar bg="dark" variant="dark" fixed="top">
            <Navbar.Brand href="#home" style={{marginLeft: 15}}>Sample</Navbar.Brand>
            {' '}
            <div style={{height: 40}}><span style={{fontSize: "8px", color: "white"}}>Version {packageJson.version}</span></div>
        </Navbar>
        <div style={{padding: 20, marginTop: 40}}>
            <h1>User</h1>
            <p>{userData.id}</p>
            <p>{userData.description}</p>
            <Card>
                <Card.Header>Groups</Card.Header>
                <ListGroup>{
                    userData.groups.map((d) => {
                        return <ListGroupItem key={d.id}>{d.id} - {d.description}</ListGroupItem>
                    })
                }</ListGroup>
            </Card>
        </div>
        <ReactJson src={userData} />
    </div>
  );
}

export default App;
