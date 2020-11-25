describe('Login', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
  })

  it('Open login page if user not signed in', function() {
    cy.visit('/')
    cy.contains('You need to sign in before continuing.')
  })

  it ('Test login functionality for admin', function() {
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.contains('Welcome admin@test.com!')
  })

  it ('Test login functionality for client', function() {
    cy.login('client@test.com', 'T3$tClient')
    cy.contains('Welcome client@test.com!')
  })

  it('Login with wrong email', function() {
    cy.visit('/')
    cy.get('[data-cy=user_email]').type('client@exapmle.com').should('have.value', 'client@exapmle.com')
    cy.get('[data-cy=user_password]').type('password').should('have.value', 'password')
    cy.get('[data-cy=user_remember_me]').click()
    cy.get('[data-cy=submit]').click()
    cy.contains('Invalid Email or password.')
  })

  it('Login with wrong password', function() {
    cy.visit('/')
    cy.get('[data-cy=user_email]').type('admin@test.com').should('have.value', 'admin@test.com')
    cy.get('[data-cy=user_password]').type('password').should('have.value', 'password')
    cy.get('[data-cy=user_remember_me]').click()
    cy.get('[data-cy=submit]').click()
    cy.contains('Invalid Email or password.')
  })

})
