import React, { useEffect, useState } from 'react';

interface Product {
  id: number;
  name: string;
  price: number;
}

const Products: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetch('http://localhost:3001/products')
      .then(response => {
        if (!response.ok) {
          throw new Error('Error during data loading.');
        }
        return response.json();
      })
      .then(data => setProducts(data))
      .catch(() => setError('Failed to load products.'))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div>
      <h1>Products</h1>

      {loading && <p>Loading products...</p>}
      {error && <p>{error}</p>}

      {!loading && !error && (
        <ul style={{ listStyle: 'none', padding: 0 }}>
          {products.map(product => (
            <li
              key={product.id}
              style={{
                marginBottom: '1rem',
                border: '1px solid #ddd',
                padding: '1rem',
                borderRadius: '8px',
              }}
            >
              <strong>{product.name}</strong>
              <br />
              <span>{product.price.toFixed(2)} PLN</span>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default Products;
