// describe('On watch issue details', function() {
//   beforeEach(() => {
//     cy.app('clean')
//     cy.appScenario('basic')
//     cy.login('admin@test.com', 'T3$tAdmin')
//     cy.openOnWatch()
//   })

//   it('Open On Watch issues to display watched issues', function() {
//     cy.get('[data-cy=watch_view]').within(() => {
//       cy.get('[data-cy=watched_issue_status]').scrollIntoView()
//       cy.get('h5').contains('Watched Issues Stats').should('be.visible')
//       cy.get('[data-cy=watched_issue_types]').within(() => {
//         cy.get('h5').contains('Watched Issue Types').should('be.visible')
//         cy.contains('Test Issue Type').should('be.visible')
//       })
//       cy.get('[data-cy=watched_issue_list]').within(() => {
//         cy.get('h5').contains('Watched Issues').should('be.visible')
//         cy.get('[data-cy=issues]').its('length').should('be.eq', 5)
//       })
//       cy.get('[data-cy=watched_issues_vs_total]').scrollIntoView()
//       cy.get('[data-cy=watched_issues_vs_total]').within(() => {
//         cy.get('h6').contains('Watched Issues vs Total').should('be.visible')
//       })
//       cy.get('[data-cy=assigned_issue_users]').within(() => {
//         cy.get('h6').contains('Assigned Users').should('be.visible')
//         cy.get('p').contains('Total Assigned Issues and Checklist Items').should('be.visible')
//       })
//     })
//     cy.logout()
//   })

//   it('When issue remove from on watch it must not appear in page', function() {
//     cy.get('[data-cy=watch_view]').within(() => {
//       cy.get('[data-cy=watched_issue_status]').scrollIntoView()
//       cy.get('[data-cy=watched_issue_list]').within(() => {
//         cy.get('h5').contains('Watched Issues').should('be.visible')
//         cy.get('[data-cy=issues]').its('length').should('be.eq', 5)
//         cy.get('[data-cy=issues]').first().click()
//       })
//       cy.get('[data-cy=issue_on_watch]').click({force: true})
//       cy.wait(1000)
//       cy.get('[data-cy=watched_issue_list]').within(() => {
//         cy.get('[data-cy=issues]').its('length').should('be.eq', 4)
//       })
//     })
//     cy.logout()
//   })
// })

// describe('On watch Page issues', function() {
//   beforeEach(() => {
//     cy.app('clean')
//     cy.appScenario('basic')
//     cy.appScenario('remove_on_watch')
//     cy.login('admin@test.com', 'T3$tAdmin')
//     cy.openOnWatch()
//   })

//   it('When no issue is on watch', function() {
//     cy.get('[data-cy=watched_issue_status]').scrollIntoView()
//     cy.get('[data-cy=no_issue_category_found]').contains('No Data Found..').should('be.visible')
//     cy.get('[data-cy=watched_issue_list]').contains('No Data Found..').should('be.visible')
//     cy.logout()
//   })
// })
