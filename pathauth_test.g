package accessauth_test

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/samsonkehinde/accessauth"
)

func TestShouldAllowUser(t *testing.T) {
	cfg.Authorization = append(cfg.Authorization, accessauth.Authorization{
		Path:     []string{"/"},
		Host:     []string{"localhost"},
		Role:  []string{"monitoring"},
	})

	ctx := context.Background()
	next := http.HandlerFunc(func(rw http.ResponseWriter, req *http.Request) {})

	handler, err := accessauth.New(ctx, next, cfg, "accessauth")
	if err != nil {
		t.Fatal(err)
	}

	recorder := httptest.NewRecorder()

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, "http://localhost/", nil)
	if err != nil {
		t.Fatal(err)
	}
	req.Header.Add("X-Roles", "admin")

	handler.ServeHTTP(recorder, req)

	assertAllowed(t, recorder, true)
}

func assertAllowed(t *testing.T, recorder *httptest.ResponseRecorder, allowed bool) {
	t.Helper()
	if recorder.Result().StatusCode == 403 && allowed {
		t.Errorf("request was forbidden, expected allowed")
	} else if recorder.Result().StatusCode != 403 && !allowed {
		t.Errorf("request was allowed, expected forbidden")
	}
}
