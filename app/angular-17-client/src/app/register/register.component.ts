import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AuthService } from '../services/auth.service';
import { Router, RouterModule } from '@angular/router';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="auth-container">
      <div class="auth-card">
        <div class="auth-header">
          <div class="auth-logo">
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <rect width="24" height="24" rx="6" fill="url(#registerGradient)"/>
              <path d="M7 12L10.5 15.5L17 9" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <defs>
                <linearGradient id="registerGradient" x1="0" y1="0" x2="24" y2="24" gradientUnits="userSpaceOnUse">
                  <stop stop-color="#6366f1"/>
                  <stop offset="1" stop-color="#8b5cf6"/>
                </linearGradient>
              </defs>
            </svg>
          </div>
          <h1>Create account</h1>
          <p class="auth-subtitle">Get started with TaskFlow today</p>
        </div>

        <form (ngSubmit)="register()" class="auth-form">
          <div class="form-group">
            <label for="username">Username</label>
            <input 
              type="text" 
              id="username"
              placeholder="Choose a username" 
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
              placeholder="Create a password" 
              [(ngModel)]="password" 
              name="password"
              autocomplete="new-password"
            />
          </div>

          <div *ngIf="errorMessage" class="error-message">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"/>
              <line x1="12" y1="8" x2="12" y2="12"/>
              <line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
            {{ errorMessage }}
          </div>

          <button type="submit" class="btn-primary btn-full">
            Create account
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="5" y1="12" x2="19" y2="12"/>
              <polyline points="12 5 19 12 12 19"/>
            </svg>
          </button>
        </form>

        <div class="auth-footer">
          <span>Already have an account?</span>
          <a routerLink="/login" class="auth-link">Sign in</a>
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

    .error-message {
      display: flex;
      align-items: center;
      gap: var(--space-2);
      padding: var(--space-3) var(--space-4);
      background-color: var(--color-error-muted);
      border: 1px solid rgba(239, 68, 68, 0.2);
      border-radius: var(--radius-md);
      color: var(--color-error);
      font-size: var(--font-size-sm);
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
export class RegisterComponent {
  username = '';
  password = '';
  errorMessage = '';

  constructor(private authService: AuthService, private router: Router) {}

  register() {
    this.errorMessage = '';
    this.authService.register(this.username, this.password)
      .then(() => {
        console.log('Użytkownik zarejestrowany');
        this.router.navigate(['/login']);
      })
      .catch(err => {
        console.error('Błąd rejestracji', err);
        this.errorMessage = err.message || 'Błąd rejestracji';
      });
  }
}
