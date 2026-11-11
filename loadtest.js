
import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 500,
  duration: '60s',
  thresholds: {
    http_req_failed: ['rate<0.05'],
    http_req_duration: ['p(95)<2000'],
  },
};

export default function () {
  const response = http.get('http://localhost:3001/', {
    timeout: '10s',
  });

  check(response, {
    'status is 200': (r) => r.status === 200,
  });
}
