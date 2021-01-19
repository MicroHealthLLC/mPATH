describe('User Profile', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openUserProfile()
  })

  it('Open/Close user profile page', function() {
    cy.get('[data-cy=cancel]').click()
    cy.logout()
  })

  it('User profile should not be update if first name is empty', function() {
    cy.get('[data-cy=first_name]').clear()
    cy.get('[data-cy=first_name_error]').contains('The firstName field is required.').should('be.visible')
    cy.get('[data-cy=update]').should('be.disabled')
    cy.logout()
  })

  it('User profile should not be update if last name is empty', function() {
    cy.get('[data-cy=last_name]').clear()
    cy.get('[data-cy=last_name_error]').contains('The lastName field is required.').should('be.visible')
    cy.get('[data-cy=update]').should('be.disabled')
    cy.logout()
  })

  it('User profile email should be read only', function() {
    cy.get('[data-cy=email]').should('have.attr', 'readonly', 'readonly')
    cy.logout()
  })

  it('User profile password should be read only', function() {
    cy.get('[data-cy=password]').should('have.attr', 'readonly', 'readonly')
    cy.logout()
  })

  it('User profile password confirmation should be read only', function() {
    cy.get('[data-cy=password_confirmation]').should('have.attr', 'readonly', 'readonly')
    cy.logout()
  })
})
