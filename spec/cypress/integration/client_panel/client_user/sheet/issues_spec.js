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
    cy.contains('No issues found..').should('be.visible')

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

  it('Sort Issue according to Issue name', function() {
    cy.get('[data-cy=issue_row]').first().contains('New Issue').should('be.visible')
    cy.get('.mt-3 > tr > :nth-child(1)').click()
    cy.get('[data-cy=issue_row]').first().contains('Test Issue').should('be.visible')
    cy.get('.mt-3 > tr > :nth-child(1)').click()
    cy.get('[data-cy=issue_row]').first().contains('New Issue').should('be.visible')
    cy.logout()
  })

  it('Sort Issue according to Assigned User', function() {
    cy.get('[data-cy=issue_row]').first().contains('Test2 Client').should('be.visible')
    cy.get('.mt-3 > tr > :nth-child(6)').click()
    cy.get('[data-cy=issue_row]').first().contains('Test1 Admin').should('be.visible')
    cy.get('.mt-3 > tr > :nth-child(6)').click()
    cy.get('[data-cy=issue_row]').first().contains('Test2 Client').should('be.visible')
    cy.logout()
  })

  // it('Select issue status from list to display related issues', function() {
  //   cy.get('[data-cy=issues_table]').within(() => {
  //     cy.get('[data-cy=issue_row]').its('length').should('be.eq', 2)
  //   })
  //   cy.get('[data-cy=issue_status_list]').as('list')
  //   cy.get('@list').click()
  //   cy.get('@list').within(() => {
  //     cy.contains('complete').click()
  //   })
  //   cy.contains('No issues found..').should('be.visible')
  //   cy.get('@list').within(() => {
  //     cy.contains('all').click()
  //   })
  //   cy.get('[data-cy=issues_table]').within(() => {
  //     cy.get('[data-cy=issue_row]').its('length').should('be.eq', 2)
  //   })
  //   cy.logout()
  // })
})
