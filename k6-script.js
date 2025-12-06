import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  iterations: 10,
};

export default function () {
  const baseUrl = 'http://web:4000/api/users';

  // GET /api/users - List all users
  let res = http.get(baseUrl);
  check(res, {
    'GET /api/users status is 200': (r) => r.status === 200,
  });
  sleep(0.1);

  // POST /api/users - Create a user
  const payload = JSON.stringify({
    user: {
      name: `K6 User ${Date.now()}`,
    },
  });
  res = http.post(baseUrl, payload, {
    headers: { 'Content-Type': 'application/json' },
  });
  check(res, {
    'POST /api/users status is 201': (r) => r.status === 201,
  });

  const userId = res.json('data.id');
  sleep(0.1);

  if (userId) {
    // GET /api/users/:id - Show a user
    res = http.get(`${baseUrl}/${userId}`);
    check(res, {
      'GET /api/users/:id status is 200': (r) => r.status === 200,
    });
    sleep(0.1);

    // PUT /api/users/:id - Update a user
    const updatePayload = JSON.stringify({
      user: {
        name: `Updated User ${Date.now()}`,
      },
    });
    res = http.put(`${baseUrl}/${userId}`, updatePayload, {
      headers: { 'Content-Type': 'application/json' },
    });
    check(res, {
      'PUT /api/users/:id status is 200': (r) => r.status === 200,
    });
    sleep(0.1);

    // DELETE /api/users/:id - Delete a user
    res = http.del(`${baseUrl}/${userId}`);
    check(res, {
      'DELETE /api/users/:id status is 204': (r) => r.status === 204,
    });
    sleep(0.1);
  }
}
