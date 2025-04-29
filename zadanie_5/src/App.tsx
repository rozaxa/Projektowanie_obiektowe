import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import Products from './components/Products';
import Payments from './components/Payments';

const App: React.FC = () => {
  return (
    <Router>
      <div style={{ maxWidth: '800px', margin: '0 auto', padding: '1rem' }}>
        <nav style={{ padding: '1rem', background: '#f5f5f5', marginBottom: '1rem' }}>
          <Link to="/" style={{ marginRight: '1rem' }}> Products </Link>
          <Link to="/payments"> Payments</Link>
        </nav>

        <Routes>
          <Route path="/" element={<Products />} />
          <Route path="/payments" element={<Payments />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
