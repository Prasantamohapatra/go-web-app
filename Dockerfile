FROM golang:1.21 AS build

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /main .

FROM gcr.io/distroless/base-debian12

WORKDIR /app
COPY --from=build /main /main
COPY --from=build /app/static ./static

EXPOSE 8080
CMD ["/main"]
