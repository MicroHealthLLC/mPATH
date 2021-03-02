describe('Sheets Issues View', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
    cy.openFacilitySheet()
    cy.get('[data-cy=facility_tabs]').contains('Issues').should('be.visible').click()
  })

  it('Open Sheets issues in a facility', function() {
    cy.get('[data-cy=issue_sheet_index]').within(() => {
      cy.get('[data-cy=issue_total]').contains('Total: 2').should('be.visible')
      cy.get('[data-cy=issues_table]').should('be.visible')
    })
    cy.logout()
  })

  it('Open issue from sheet issue table', function() {
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').first().should('be.exist').click({force: true})
    })
    cy.get('[data-cy=issue_close_btn]').should('be.exist').click({force: true})
    cy.logout()
  })

  it('Search issue by typing title', function() {
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 2)
    })
    cy.get('[data-cy=search_issues]').clear().type('Issue is not in the list').should('have.value', 'Issue is not in the list')
    cy.contains('No Issues found...').should('be.visible')

    cy.get('[data-cy=search_issues]').clear().type('Test Issue').should('have.value', 'Test Issue')
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 1)
    })
    cy.get('[data-cy=search_issues]').clear()
    cy.get('[data-cy=issues_table]').within(() => {
      cy.get('[data-cy=issue_row]').its('length').should('be.eq', 2)
    })
    cy.logout()
  })
})
