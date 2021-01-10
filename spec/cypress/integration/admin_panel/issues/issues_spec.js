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

  it('Search Issue contains name', function() {
    cy.get('#q_title').type('Test Issue 1').should('have.value', 'Test Issue 1')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').scrollIntoView()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Title contains Test Issue 1').should('be.visible')
    cy.get('#index_table_issues > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
    cy.get('#logout').click()
  })
})
