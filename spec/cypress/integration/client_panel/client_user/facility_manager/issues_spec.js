describe('Issue List', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
    cy.issueList()
  })

  it('Open Issue list page of a Facility', function() {
    cy.get('[data-cy=issue_list]').contains('My Issue').should('be.visible')
    cy.logout()
  })

  it('Cannot open new Issue form and edit/delete existing issue', function() {
    cy.get('[data-cy=new_issue]').should('not.exist')
    cy.get('[data-cy=issues]').first().click()
    cy.contains('Issue Name:')
    cy.get('[data-cy=issue_read_only_btn]').should('be.disabled')
    cy.get('[data-cy=issue_delete_btn]').should('not.exist')
    cy.get('[data-cy=issue_close_btn]').click()
    cy.logout()
  })

  it('Search issue by typing title', function() {
    cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    cy.get('[data-cy=search_issues]').clear().type('Issue is not in the list').should('have.value', 'Issue is not in the list')
    cy.contains('No issues found..').should('be.visible')

    cy.get('[data-cy=search_issues]').clear().type('Test Issue').should('have.value', 'Test Issue')
    cy.get('[data-cy=issues]').its('length').should('be.eq', 1)

    cy.get('[data-cy=search_issues]').clear()
    cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    cy.logout()
  })

  it('Select issue status from list to display related issues', function() {
    cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    cy.get('[data-cy=issue_status_list]').as('list')
    cy.get('@list').click()
    cy.get('@list').within(() => {
      cy.contains('complete').click()
    })
    cy.contains('No issues found..').should('be.visible')
    cy.get('@list').within(() => {
      cy.contains('all').click()
    })
    cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    cy.logout()
  })
})
