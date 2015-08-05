if rand(2) == 0
  Nginx.return Nginx::HTTP_OK
else
  Nginx.return Nginx::HTTP_FORBIDDEN
end
