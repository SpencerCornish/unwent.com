import React from "react";
import { createNewGoogleUser, logOut } from "../firebase/auth.js";
import { auth } from "firebase";


class Home extends React.Component {

    constructor(props) {
        super(props);
    }

    render() {
        if (this.props.user) {
            return this.RenderHome();
        }
        return this.RenderLogin();
    }

    RenderLogin() {
        return (
            <div>
                <p>Banana</p>
                <button onClick={createNewGoogleUser}>Click to login!</button>
            </div>
        );
    }

    RenderHome() {
        return (
            <div>
                <p>{this.props.user.displayName}</p>
                <button onClick={logOut}>Click to logout!</button>
            </div>
        );
    }

}

export default Home;
