describe('Admin Panel Statuses', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openStatusAP()
  })

  it('Click on Statuses on tabs open Status information page', function() {
    cy.get('#page_title').contains('Statuses').should('be.visible')
    cy.get('#index_table_statuses').should('be.visible')
    cy.get('#index_table_statuses > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })

  it('Open and close new Status form', function() {
    cy.get('.action_item > a').contains('New Status').click()
    cy.get('#page_title').contains('New Status').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  it('Create new Status', function() {
    cy.get('.action_item > a').contains('New Status').click()
    cy.get('#page_title').contains('New Status').should('be.visible')
    cy.get('#status_name').type('New Test Status')
    cy.get('#status_submit_action').contains('Create Status').click()
    cy.get('.flashes').contains('Status was successfully created.')
    cy.get('#index_table_statuses > tbody > tr').its('length').should('be.eq', 3)
    cy.get('#logout').click()
  })

  it('Could not Delete Status of foreign constraint', function() {
    cy.get('#index_table_statuses').should('be.visible')
    cy.get('#index_table_statuses > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Not able to delete this! Violates foreign key constraint.').should('be.visible')
    cy.get('#index_table_statuses > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })
})
