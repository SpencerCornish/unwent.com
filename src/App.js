import React from "react";
import { user } from "./firebase/auth.js";
import { BrowserRouter as Router, Route } from "react-router-dom";

import Home from "./pages/Home";
// import Login from "./Login";
// import SignUp from "./SignUp";

const App = () => {
  return (
    <Router>
      <div>
        <Route exact path="/" component={Home} />
      </div>
    </Router>
  );
};

export default App;
