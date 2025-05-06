import React, { useState } from 'react';

const Payments: React.FC = () => {
  const [amount, setAmount] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  const handlePayment = () => {
    const value = parseFloat(amount);

    if (!value || value <= 0) {
      setMessage('Enter a valid amount');
      return;
    }

    setLoading(true);
    setMessage(null);

    fetch('http://localhost:3001/payments', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ amount: value, date: new Date() })
    })
      .then(response => {
        if (response.ok) {
          setMessage('Payment sent!');
          setAmount('');
        } else {
          setMessage('Error sending payment');
        }
      })
      .catch(() => setMessage('Connection to server failed'))
      .finally(() => setLoading(false));
  };

  return (
    <div>
      <h1>Payments</h1>
      <div style={{ marginBottom: '1rem' }}>
        <input
          type="number"
          placeholder="Amount"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          style={{ padding: '0.5rem', marginRight: '0.5rem' }}
        />
        <button onClick={handlePayment} disabled={loading}>
          {loading ? 'Sending...' : 'Send Payment'}
        </button>
      </div>
      {message && <p>{message}</p>}
    </div>
  );
};

export default Payments;
