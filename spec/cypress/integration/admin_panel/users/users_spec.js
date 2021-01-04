describe('Admin Panel Users', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openUserAP()
  })

  it('Click on Users on tabs open users information page', function() {
    cy.get('#page_title').contains('Users').should('be.visible')
    cy.get('#index_table_users').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })

  it('Open and close new User form', function() {
    cy.get('.action_item > a').contains('New User').click()
    cy.get('#page_title').contains('New User').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  it('Could not Delete User of foreign constraint', function() {
    cy.get('#index_table_users').should('be.visible')
    cy.get('#index_table_users > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Not able to delete this! Violates foreign key constraint.').should('be.visible')
    cy.get('#index_table_users > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })
})
