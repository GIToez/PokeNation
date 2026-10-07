////////////////////////////////////////////////////////////////////////
// OpenTibia - an opensource roleplaying game
////////////////////////////////////////////////////////////////////////
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
////////////////////////////////////////////////////////////////////////
#include "otpch.h"

#include "polls.h"
#include "iopoll.h"

#include "iologindata.h"
#include "configmanager.h"
#include "scheduler.h"

extern ConfigManager g_config;

Poll::Poll(uint32_t id, std::string name, std::string question, uint64_t deadline, PollOptionsMap pollOptions, bool textMode)
{
    m_id = id;
    m_name = name;
    m_question = question;
    m_deadline = deadline;
    m_pollOptions = pollOptions;
    m_textMode = textMode;
}

Poll::~Poll()
{
}

uint32_t Poll::getId()
{
    return m_id;
}

std::string Poll::getName()
{
    return m_name;
}

std::string Poll::getQuestion()
{
    return m_question;
}

uint64_t Poll::getDeadline()
{
    return m_deadline;
}

bool Poll::getTextMode()
{
    return m_textMode;
}

PollOptionsMap* Poll::getPollOptions()
{
    return &m_pollOptions;
}
//

Polls::Polls()
{
}

Polls::~Polls()
{
    clear();
}

void Polls::clear()
{
    for (PollsMap::iterator it = pollsMap.begin(); it != pollsMap.end(); ++it) {
        delete it->second;
    }
    
    pollsMap.clear();
}

void Polls::load()
{
    clear();
    checkPolls();
}

bool Polls::registerPoll(uint32_t pollId, std::string pollName, std::string pollQuestion,
        uint64_t deadline, bool textMode, PollOptionsMap pollOptions)
{
    PollsMap::iterator it = pollsMap.find(pollId);
    if (it == pollsMap.end()) {
        Poll* poll = new Poll(pollId, pollName, pollQuestion, deadline, pollOptions, textMode);
        if (poll) {
            pollsMap[pollId] = poll;
            return true;
        }
    }
    
    return false;
}

Poll* Polls::getAvailablePollForAccount(uint32_t accountNumber)
{
    if (IOLoginData::getInstance()->getAccountHighestLevel(accountNumber) >= g_config.getNumber(ConfigManager::MINIMUM_LEVEL_TO_POLL_VOTE)) {
        for (PollsMap::iterator it = pollsMap.begin(); it != pollsMap.end(); ++it) {
            if (time(NULL) < it->second->getDeadline() &&
                !IOPoll::getInstance()->getAccountVoted(accountNumber, it->second)) {
                return it->second;
            }
        }
    }
    
    return NULL;
}

bool Polls::doComputePollVote(uint32_t accountNumber, uint8_t pollVote)
{
    Poll* poll = getAvailablePollForAccount(accountNumber);
    if (!poll) {
        return false;
    }
    
    PollOptionsMap* pollOptions = poll->getPollOptions();
    PollOptionsMap::iterator it = pollOptions->find(pollVote);
    if (it == pollOptions->end()) {
        return false;
    }
    
    return IOPoll::getInstance()->doComputePollVote(poll->getId(), accountNumber, pollVote);
}

bool Polls::doComputePollVote(uint32_t accountNumber, std::string text)
{
    Poll* poll = getAvailablePollForAccount(accountNumber);
    if (!poll) {
        return false;
    }
    
    return IOPoll::getInstance()->doComputePollVote(poll->getId(), accountNumber, text);
}

void Polls::checkPolls()
{
    IOPoll::getInstance()->loadPolls();
    Scheduler::getInstance().addEvent(createSchedulerTask(10 * 1000, boost::bind(&Polls::checkPolls, this)));
}
