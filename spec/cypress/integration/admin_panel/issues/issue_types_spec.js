describe('Admin Panel Issue Types', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openIssueTypeAP()
  })

  it('Click on Issue Types on tabs open Issue Type information page', function() {
    cy.get('#page_title').contains('Issue Types').should('be.visible')
    cy.get('#index_table_issue_types').should('be.visible')
    cy.get('#index_table_issue_types > tbody > tr').its('length').should('be.eq', 1)
    cy.get('#logout').click()
  })

  it('Open and close new Issue Type form', function() {
    cy.get('.action_item > a').contains('New Issue Type').click()
    cy.get('#page_title').contains('New Issue Type').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })
})
