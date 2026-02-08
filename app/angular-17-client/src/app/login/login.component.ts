import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AuthService } from '../services/auth.service';
import { Router, RouterModule } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="auth-container">
      <div class="auth-card">
        <div class="auth-header">
          <div class="auth-logo">
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <rect width="24" height="24" rx="6" fill="url(#loginGradient)"/>
              <path d="M7 12L10.5 15.5L17 9" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <defs>
                <linearGradient id="loginGradient" x1="0" y1="0" x2="24" y2="24" gradientUnits="userSpaceOnUse">
                  <stop stop-color="#6366f1"/>
                  <stop offset="1" stop-color="#8b5cf6"/>
                </linearGradient>
              </defs>
            </svg>
          </div>
          <h1>Welcome back</h1>
          <p class="auth-subtitle">Sign in to continue to TaskFlow</p>
        </div>

        <form (ngSubmit)="login()" class="auth-form">
          <div class="form-group">
            <label for="username">Username</label>
            <input 
              type="text" 
              id="username"
              placeholder="Enter your username" 
              [(ngModel)]="username" 
              name="username"
              autocomplete="username"
            />
          </div>

          <div class="form-group">
            <label for="password">Password</label>
            <input 
              type="password" 
              id="password"
              placeholder="Enter your password" 
              [(ngModel)]="password" 
              name="password"
              autocomplete="current-password"
            />
          </div>

          <button type="submit" class="btn-primary btn-full">
            Sign in
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="5" y1="12" x2="19" y2="12"/>
              <polyline points="12 5 19 12 12 19"/>
            </svg>
          </button>
        </form>

        <div class="auth-footer">
          <span>Don't have an account?</span>
          <a routerLink="/register" class="auth-link">Create account</a>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .auth-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: var(--space-4);
      background-color: var(--color-bg-primary);
    }

    .auth-card {
      width: 100%;
      max-width: 400px;
      background-color: var(--color-bg-secondary);
      border: 1px solid var(--color-border);
      border-radius: var(--radius-xl);
      padding: var(--space-8);
      animation: slideUp var(--transition-slow) ease;
    }

    .auth-header {
      text-align: center;
      margin-bottom: var(--space-8);
    }

    .auth-logo {
      display: flex;
      justify-content: center;
      margin-bottom: var(--space-6);
    }

    .auth-logo svg {
      width: 48px;
      height: 48px;
    }

    .auth-header h1 {
      font-size: var(--font-size-2xl);
      font-weight: var(--font-weight-semibold);
      color: var(--color-text-primary);
      margin-bottom: var(--space-2);
    }

    .auth-subtitle {
      color: var(--color-text-tertiary);
      font-size: var(--font-size-sm);
    }

    .auth-form {
      display: flex;
      flex-direction: column;
      gap: var(--space-5);
    }

    .form-group {
      display: flex;
      flex-direction: column;
      gap: var(--space-2);
    }

    .btn-primary {
      width: 100%;
      padding: var(--space-4);
      font-size: var(--font-size-base);
      margin-top: var(--space-2);
    }

    .btn-full {
      width: 100%;
    }

    .auth-footer {
      margin-top: var(--space-6);
      text-align: center;
      padding-top: var(--space-6);
      border-top: 1px solid var(--color-border);
      font-size: var(--font-size-sm);
      color: var(--color-text-tertiary);
    }

    .auth-link {
      color: var(--color-accent);
      font-weight: var(--font-weight-medium);
      margin-left: var(--space-2);
    }

    .auth-link:hover {
      color: var(--color-accent-hover);
    }

    @keyframes slideUp {
      from {
        opacity: 0;
        transform: translateY(16px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
  `]
})
export class LoginComponent {
  username = '';
  password = '';

  constructor(private authService: AuthService, private router: Router) {}

  login() {
    this.authService.login(this.username, this.password)
    .then(() => this.router.navigate(['/']))
    .catch(err => console.error('Błąd logowania', err));
  }
}