describe('On watch timeline Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
    cy.openOnWatch()
  })

  it('Open On Watch timeline to display the summary of watched', function() {
    cy.get('[data-cy=watch_view]').within(() => {
      cy.get('[data-cy=watch_task_timeline]').within(() => {
        cy.get('h5').contains('On Watch Timeline').should('be.visible')
      })
      cy.get('[data-cy=total_watched_tasks]').scrollIntoView()
      // total watched tasks
      cy.get('[data-cy=total_watched_tasks]').within(() => {
        cy.get('h6').contains('Total Number of Watched Tasks').should('be.visible')
        cy.get('h1').contains('5').should('be.visible')
      })
      // total watched issues
      cy.get('[data-cy=total_watched_issues]').within(() => {
        cy.get('h6').contains('Total Number of Watched Issues').should('be.visible')
        cy.get('h1').contains('5').should('be.visible')
      })
      // total watched facilities
      cy.get('[data-cy=total_watched_facilities]').within(() => {
        cy.get('h6').contains('Facilities on Watch').should('be.visible')
        cy.get('h1').contains('3').should('be.visible')
      })
      // In progress tasks
      cy.get('[data-cy=in_progress_tasks]').within(() => {
        cy.get('h6').contains('Watched Task Progress').should('be.visible')
      })
      // In progress issues
      cy.get('[data-cy=in_progress_issues]').within(() => {
        cy.get('h6').contains('Watched Issue Progress').should('be.visible')
      })
      // Overdue tasks and issues
      cy.get('[data-cy=overdue_details]').within(() => {
        cy.get('h6').contains('Overdue Tasks and Issues').should('be.visible')
        cy.get('h1').contains('0').should('be.visible')
      })
      // Facilities details
      cy.get('[data-cy=watched_facilities]').within(() => {
        cy.get('h5').contains('Watched Facilities, Status and % Progress').should('be.visible')
        cy.contains('Test Facility 1').should('be.visible')
        cy.contains('Test Facility 2').should('be.visible')
        cy.contains('Test Facility 3').should('be.visible')
      })
    })
    cy.logout()
  })
})

describe('On watch timeline Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('remove_on_watch')
    cy.login('client@test.com', 'T3$tClient')
    cy.openOnWatch()
  })

  it('Without on watch tasks and issues', function() {
    cy.get('[data-cy=watch_view]').within(() => {
      cy.get('[data-cy=watch_task_timeline]').within(() => {
        cy.get('h5').contains('On Watch Timeline').should('be.visible')
      })
      cy.get('[data-cy=total_watched_tasks]').scrollIntoView()
      // total watched tasks
      cy.get('[data-cy=total_watched_tasks]').within(() => {
        cy.get('h6').contains('Total Number of Watched Tasks').should('be.visible')
        cy.get('h1').contains('0').should('be.visible')
      })
      // total watched issues
      cy.get('[data-cy=total_watched_issues]').within(() => {
        cy.get('h6').contains('Total Number of Watched Issues').should('be.visible')
        cy.get('h1').contains('0').should('be.visible')
      })
      // total watched facilities
      cy.get('[data-cy=total_watched_facilities]').within(() => {
        cy.get('h6').contains('Facilities on Watch').should('be.visible')
        cy.get('h1').contains('0').should('be.visible')
      })
      // In progress tasks
      cy.get('[data-cy=in_progress_tasks]').within(() => {
        cy.get('h6').contains('Watched Task Progress').should('be.visible')
      })
      // In progress issues
      cy.get('[data-cy=in_progress_issues]').within(() => {
        cy.get('h6').contains('Watched Issue Progress').should('be.visible')
      })
      // Overdue tasks and issues
      cy.get('[data-cy=overdue_details]').within(() => {
        cy.get('h6').contains('Overdue Tasks and Issues').should('be.visible')
        cy.get('h1').contains('0').should('be.visible')
      })
      // Facilities details
      cy.get('[data-cy=watched_facilities]').within(() => {
        cy.get('h5').contains('Watched Facilities, Status and % Progress').should('be.visible')
        cy.get('[data-cy=no_facility_found]').contains('No Data Found..').should('be.visible')
      })
      // Task Details
      cy.get('[data-cy=watched_task_status]').scrollIntoView()
      cy.get('[data-cy=no_task_category_found]').contains('No Data Found..').should('be.visible')
      cy.get('[data-cy=no_task_found]').contains('No Data Found..').should('be.visible')

      // Issue Details
      cy.get('[data-cy=watched_issue_status]').scrollIntoView()
      cy.get('[data-cy=no_issue_category_found]').contains('No Data Found..').should('be.visible')
      cy.get('[data-cy=watched_issue_list]').contains('No Data Found..').should('be.visible')
    })
    cy.logout()
  })
})

describe('Client do not have permission of on watch view', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('remove_on_watch_permission')
    cy.login('client@test.com', 'T3$tClient')
  })

  it('On watch tab not display in tab panel', function() {
    cy.openProject()
    cy.get('[data-cy=on_watch_tab]').should('not.exist')
    cy.logout()
  })
})

