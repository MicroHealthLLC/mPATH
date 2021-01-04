describe('Admin Panel Issue', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openIssueAP()
  })

  it('Click on Issues on tabs open Issue information page', function() {
    cy.get('#page_title').contains('Issues').should('be.visible')
    cy.get('#index_table_issues').should('be.visible')
    cy.get('#index_table_issues > tbody > tr').its('length').should('be.eq', 6)
    cy.get('#logout').click()
  })

  it('Delete Issue', function() {
    cy.get('#index_table_issues').should('be.visible')
    cy.get('#index_table_issues > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Issue was successfully destroyed.').should('be.visible')
    cy.get('#index_table_issues > tbody > tr').its('length').should('be.eq', 5)
    cy.get('#logout').click()
  })
})
